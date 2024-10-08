# Toggle Mouse Cursor

<p align="center">
  <img src="./media/preview.gif" alt="animated">
</p>
<p align="center">
  <code>tmc_togglemousecursor</code> to lock or unlock the mouse
</p>

This addon adds the console command `tmc_togglemousecursor` which enables free mouse cursor movement without moving the crosshair. You can then bind a key to this console command to toggle mouse cursor movement.

This addon works in the same way as holding C to open the tool control panel. However, this console command keeps the mouse free until the command is called again.

This is useful for scenarios which require precise mouse movement, as opposed to the crosshair which is locked to mouse sensitivity. 

Every time this command runs, you will hear a sound and receive a notification at the center of your crosshair. You can enable or disable notifications with `tmc_notifications`.

## Note

This addon overrides `gui.EnableScreenClicker` to preserve the unlocked cursor state. This addon will still work even if other addons override this function; however, if the cursor is unlocked and another addon disables screen clicking, the cursor will lock. 

Toggle `tmc_togglemousecursor` again to fix inconsistent behaviors. Otherwise, expect undefined behavior due to this incompatibility.