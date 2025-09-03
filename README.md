# Nameplate Scaling

A lightweight addon for World of Warcraft **Project Epoch** (3.3.5) that enhances the **default Blizzard nameplates**. It applies your UI scaling to nameplates (so they respect the same scaling as the rest of your UI) and introduces a few carefully chosen tweaks to improve readability and visual polish.

## Installation

1. Download the latest release from the [Releases page](https://github.com/jvanmourik/NameplateScaling/releases).
2. Extract the `.zip` file.
3. Move the extracted folder into your World of Warcraft `Interface/AddOns` directory.
   - Example: `epoch_live/Interface/AddOns/NameplateScaling`
4. Restart WoW.

You should now see the changes applied to your default nameplates.

## Features

### Scaled nameplates
By default, Blizzard nameplates don’t follow your UI scale. This addon fixes that.

<p float="left">
  <img width="350" height="350" alt="Before scaling the nameplate" src="https://github.com/user-attachments/assets/363cf1ca-bbb1-48f4-9942-2b8bd2ac0db6" />
  <img width="350" height="350" alt="After scaling the nameplate" src="https://github.com/user-attachments/assets/3b4fd006-7b48-4f7a-9e9f-3946c5a5d900" />
</p>

### Nameplate sorting
Sorts nameplates by distance to improve visibility when multiple units overlap

<p float="left">
  <img width="350" height="350" alt="before-sort" src="https://github.com/user-attachments/assets/cb06080e-c8a6-494d-9425-4a7f505caa01" />
  <img width="350" height="350" alt="after-sort" src="https://github.com/user-attachments/assets/ac832d39-42ee-4b2e-900d-2c85020a8ddd" />
</p>

### Bar backgrounds
Adds a subtle background to both the health and cast bars for better contrast, just like in WoW Classic.

<p float="left">
  <img width="350" height="350" alt="Before adding a background" src="https://github.com/user-attachments/assets/3dc59bc2-9f16-433b-b8bd-575e9778bd4a" />
  <img width="350" height="350" alt="After adding a background" src="https://github.com/user-attachments/assets/4390868b-499e-4603-a699-6b8ae1341de9" />
</p>

### Improved CVar settings

This addon automatically applies the following tweaks for a smoother nameplate experience.

> [!IMPORTANT]
> CVars are client options and thus will remain after uninstalling the addon. You can revert these options back to default by running the first `/console` command listed in every section below.

#### Raised nameplates

Keeps nameplates slightly higher above mobs and players, reducing overlap.

`/console nameplateZ 0` → `/console nameplateZ 1`
  
<p float="left">
  <img width="350" height="350" alt="Before raising the nameplate" src="https://github.com/user-attachments/assets/a0c10497-98c1-456e-9ad2-b081aba1041e" />
  <img width="350" height="350" alt="After raising the nameplate" src="https://github.com/user-attachments/assets/bdf99fdb-0427-449e-8c32-0159287ae3dd" />
</p>

#### Fade behind terrain

Nameplates no longer remain fully visible when the entity is behind terrain.

`/console nameplateIntersectOpacity 1` → `/console nameplateIntersectOpacity 0.1`

<p float="left">
  <img width="350" height="350" alt="Before fading occluded nameplate" src="https://github.com/user-attachments/assets/a3a184a1-a67a-4966-a98c-bad831244720" />
  <img width="350" height="350" alt="After fading occluded nameplate" src="https://github.com/user-attachments/assets/72010fab-2d10-4812-b5d1-2e06c0fb6e63" />
</p>

#### Camera-Based Intersection

Ensures the nameplate intersection is calculated from the camera to the entity instead of from the player, making occlusion more accurate.

`/console nameplateIntersectUseCamera 0` → `/console nameplateIntersectUseCamera 1`

#### Smooth Fade-In

Nameplates no longer pop in instantly, they fade in smoothly when appearing.

`/console nameplateFadeIn 0` → `/console nameplateFadeIn 1`
