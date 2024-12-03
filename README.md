# Toggle Mouse Cursor

<p align="center">
  <img src="./media/preview.gif" alt="animated">
</p>
<p align="center">
  <code>tmc_togglemousecursor</code> to lock or unlock the mouse
</p>

This addon adds the following console commands: 
- `tmc_togglemousecursor` to toggle free mouse cursor movement without moving the crosshair. You can bind a key to this console command,
- `tmc_blockentitymenu [0/1]` to enable/disable entity menus when right-clicking on an entity, and
- `tmc_notifications [0/1]` to enable/disable customizable notification text and sound.

This addon works in the same way as holding C to open the tool control panel. However, this console command keeps the mouse free until the command is called again.

This is useful for scenarios which require precise mouse movement, as opposed to the crosshair which is locked to mouse sensitivity. 

## Note

This addon detours the following functions:
- `gui.EnableScreenClicker` to preserve the unlocked cursor state,
- `properties.OpenEntityMenu` to block the EntityMenu when unlocked and when `tmc_blockentitymenu 1`.

Toggle `tmc_togglemousecursor` again to fix inconsistent behaviors.