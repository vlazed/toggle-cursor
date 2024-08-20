# Toggle Mouse Cursor

<p align="center">
  <img src="./media/preview.gif" alt="animated">
</p>
<p align="center">
  <code>tmc_togglemousecursor</code> to lock or unlock the moyse
</p>

This addon adds the console command `tmc_togglemousecursor` which enables free mouse cursor movement without moving the crosshair. You can then bind a key to this console command to toggle mouse cursor movement.

This is useful for scenarios which require precise mouse movement, as opposed to the crosshair which is locked to mouse sensitivity. 

Every time this command runs, you will hear a sound and receive a notification at the center of your crosshair. You can enable or disable notifications with `tmc_notifications`.

## Note

While this addon does free the mouse cursor, the screen has a "dead" area located around the crosshair where the selected tool or weapon may no longer follow. When the cursor enters this area, the tool or weapon snaps to the crosshair. (The regular context menu also suffers from this). 