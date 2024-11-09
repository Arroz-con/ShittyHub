local Keyboard

function Keyboard:keyPressForMoving()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
    task.wait(2)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.W, false, game)
    task.wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.S, false, game)
    task.wait(2)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.S, false, game)
    task.wait()
end

return Keyboard

