![Loadify](https://vishwaiosdev.github.io/global-images/loadify-cover.png)

# Loadify

Loadify is an iOS and iPad app designed for downloading high-quality content from Instagram (reels, posts, stories), TikTok videos, Facebook videos, and LinkedIn videos. Simply copy and paste the URL of the desired content, and download it in the best available quality.

# Requirements

- iOS 17.0+
- iPadOS 17.0+

# Features

- High-quality downloads (best available quality)
- Instagram: reels, posts, and stories
- Facebook: videos
- LinkedIn: videos
- TikTok: videos

**🌈 Beautiful Progress Bar:** Immerse yourself in the download experience with our vibrant progress bar. Watch as your video downloads in real-time, colorfully indicating the progress at a glance.

## Screenshots

<div style="flex-direction: row"> 
    <img src="https://github.com/user-attachments/assets/cb3a1fef-695e-4fe0-aaaa-5e53af80418b" />
</div>

## Setup

Follow the steps below to setup Loadify on your machine:

- Download and install [**Xcode 26**](https://apps.apple.com/in/app/xcode/id497799835?mt=12)
- Clone [**Loadify-iOS**](https://github.com/VishwaiOSDev/Loadify-iOS) from GitHub
- Open `Loadify.xcodeproj` file
- Run the app after packages have been fetched

## ⚠️ Troubleshooting

### Package Issues
If Xcode fails to resolve packages or you see dependency errors:

- Go to **File → Packages → Reset Package Caches**  
- Then go to **File → Packages → Resolve Package Versions**

### LoadifyEngine Errors
If you see errors related to **LoadifyEngine**:

1. Open **Project Settings → Signing & Capabilities**  
2. Select your own team (Apple ID) under **Signing**  
3. Clean and build the project again  

> ℹ️ Xcode will re-sign the app and the embedded framework automatically with your Apple ID.  
> No manual setup is needed beyond selecting your team once.

## Packages Dependency

The packages listed below are used by Loadify:

- [FontKit](https://github.com/VishwaiOSDev/FontKit)
- [LoggerKit](https://github.com/VishwaiOSDev/LoggerKit)
- [Haptific](https://github.com/Vignesh-Thangamariappan/Haptific)

## Use LoadifyEngine in Your App

LoadifyEngine is the **core framework that powers Loadify**.

📘 **Integration Guide:** [Use LoadifyEngine in Your App](Docs/LoadifyEngine.md)

## Roadmap

- 🚧 **Twitter / X** — Working in progress  
- 🔜 **YouTube** — Coming soon  
- 🚧 **Liquid Glass Design** — Working in progress  
- 🚧 **Parallel Download** — Working in progress  

## 💬 Community & Discord

<div align="center">
  <p><strong>Join our community to contribute, discuss, and stay up to date with new releases.</strong></p>
  <a href="https://discord.gg/GhteDnmBH7" target="_blank">
    <img alt="Join our Discord" src="https://img.shields.io/badge/Join%20our%20Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white">
  </a>
  <p>
    <sub>👋 Friendly Q&A • 💡 Feature ideas • 📣 Release notes & sneak peeks</sub>
  </p>
</div>

## Support

If you find Loadify useful, consider starring ⭐ the repo or sponsoring my work.  
Your support helps me keep improving Loadify and building more tools for the iOS community.  

💡 Have a feature request or idea? Feel free to [open an issue](../../issues) — I’d love to hear your suggestions!
