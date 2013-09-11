
#include <boost/filesystem.hpp>
#include <base/file/stream.h>
#include <base/path/service.h>
#include <base/win/env_variable.h>
#include <base/win/process.h>
#include <slk/reader/IniReader.hpp>
#include <base/warcraft3/directory.h>

bool launch_warcraft3()
{
	try {
		boost::filesystem::path ydwe_path = ydwe::path::get(ydwe::path::DIR_EXE).remove_filename().remove_filename();

		ydwe::win::env_variable ev(L"PATH");
		std::wstring p;
		p += (ydwe_path / L"bin").c_str();    p += L";"; 
		ev.set(p + ev.get());

		boost::filesystem::path war3_path;
		if (!ydwe::warcraft3::directory::get(nullptr, war3_path))
		{
			return false;
		}

		boost::filesystem::path inject_dll = ydwe_path / L"plugin" / L"warcraft3" / L"yd_loader.dll";
		std::wstring command_line = L"\"" + war3_path.wstring() + L"\"";

		slk::IniTable table;
		table["MapTest"]["LaunchOpenGL"]   = "0";
		table["MapTest"]["LaunchWindowed"] = "1";
		try {
			slk::buffer buf = ydwe::file::read_stream(ydwe_path / L"bin" / L"EverConfig.cfg").read<slk::buffer>();
			slk::buffer_reader reader(buf);
			slk::IniReader::Read(reader, table);
		} 
		catch (...) {
		}

		if ("0" != table["MapTest"]["LaunchOpenGL"])
		{
			command_line += L" -opengl";
		}

		if ("0" != table["MapTest"]["LaunchWindowed"])
		{
			command_line += L" -window";
		}

		ydwe::win::process warcraft3_process;

		if (boost::filesystem::exists(inject_dll))
		{
			command_line += L" -ydwe \"";
			command_line += ydwe_path.wstring();
			command_line += L"\"";

			warcraft3_process.inject(inject_dll);			
		}

		return warcraft3_process.create(war3_path / L"war3.exe", command_line);

	}
	catch (...) {
	}

	return false;
}
