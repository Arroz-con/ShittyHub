local Keyboard = {}

function Keyboard:keyPressForMoving()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
    task.wait(3)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.W, false, game)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.S, false, game)
    task.wait(3)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.S, false, game)
    task.wait()
end

function Keyboard:keyPressForMoving2()
    keypress(0x57)
    task.wait(3)
    keyrelease(0x57)
    task.wait()
    keypress(0x53)
    task.wait(3)
    keyrelease(0x53)
    task.wait()
end

return Keyboard

