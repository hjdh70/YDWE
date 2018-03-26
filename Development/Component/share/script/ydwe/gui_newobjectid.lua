return function(default, f)
    local gui = require 'yue.gui'

    local win = gui.Window.create { frame = false }
    win:sethasshadow(true)
    win:setresizable(false)
    win:setmaximizable(false)
    win:setminimizable(false)
    win:setalwaysontop(true)
    win:setcontentsize { width = 250, height = 110 }
    win:center()
    win:activate()

    local view = gui.Container.create()
    win:setcontentview(view)

    local title = gui.Container.create()
    title:setstyle { FlexGrow = 1, Height = 25, FlexDirection = 'row', AlignItems = 'center' }
    title:setbackgroundcolor('#28c')
    title:setmousedowncanmovewindow(true)
    view:addchildview(title)

    local title_label = gui.Label.create('新物体的ID')
    title_label:setstyle { Height = 20, Width = 100 }
    title_label:setcolor('#eee')
    title_label:setfont(gui.Font.create('宋体', 16, "bold", "normal"))
    title_label:setmousedowncanmovewindow(true)
    title:addchildview(title_label)

    local content = gui.Container.create()
    view:addchildview(content)

    local entry = gui.Entry.create()
    entry:setstyle { Height = 22, Margin = 10, MarginBottom = 0 }
    entry:settext(default)
    content:addchildview(entry)

    local tip = gui.Label.create('')
    tip:setstyle { Height = 20 }
    tip:setcolor('#c22')
    tip:setfont(gui.Font.create('宋体', 12, "bold", "normal"))
    content:addchildview(tip)

    local btnView = gui.Container.create()
    btnView:setstyle { FlexDirection = 'row-reverse' }
    content:addchildview(btnView)

    local btnCancel = gui.Button.create('使用默认')
    btnCancel:setstyle { Margin = 10, Width = 70, MarginTop = 0 }
    btnView:addchildview(btnCancel)

    local btnOK = gui.Button.create('确定')
    btnOK:setstyle { Margin = 10, Width = 70, MarginTop = 0 }
    btnView:addchildview(btnOK)


    local function is_valid(r)
        if #r ~= 4 then
            return '物体ID的长度必须为4'
        end
    end

    local function finish(r)
        local err = is_valid(r)
        if err then
            tip:settext(err)
            return
        end
        err = f(r)
        if err then
            tip:settext(err)
            return
        end
        win:close()
    end

    -- TODO:
    -- function entry:ontextchange()
    -- end

    function entry:onactivate()
        finish(entry:gettext())
    end

    function btnOK:onclick()
        finish(entry:gettext())
    end

    function btnCancel:onclick()
        finish(default)
    end
end