<img width="2000" height="600" alt="Loadify Engine Cover" src="https://github.com/user-attachments/assets/aa780d41-7c32-4263-ad71-9375a92f55b7" />

# LoadifyEngine

A lightweight Swift framework for extracting downloadable video details from popular social platforms. Given a post URL from TikTok, Instagram, or X (Twitter), LoadifyEngine fetches normalized metadata such as a direct video URL and thumbnail so you can handle downloads in your app.

- Framework target: `LoadifyEngine`

## Features
- Infers platform from a URL and routes to the appropriate fetcher
- Supports TikTok, Instagram, and X (Twitter)
- Unified response model (`LoadifyResponse`) with platform, user (optional), and video details
- Async/await API (Swift Concurrency)
- Built-in per-platform rate limiting
- Mock mode for offline/demo runs

## Requirements
- Swift tools: 6.0
- Platforms: iOS 14+, macOS 10.15+

See your Xcode target settings for deployment details.

## Installation (Framework)
You can integrate LoadifyEngine as a framework in a couple of ways:

### Option 1: Use a prebuilt XCFramework
1. Download `LoadifyEngine.xcframework` from your distribution (e.g., a Releases page).
2. In Xcode, select your app target.
3. Go to General > Frameworks, Libraries, and Embedded Content.
4. Drag `LoadifyEngine.xcframework` into the project (or click the + button to add it).
5. Make sure the embed setting is set to “Embed & Sign”.

### Option 2: Add the framework as a subproject
1. Drag `LoadifyEngine.xcodeproj` into your app’s workspace.
2. In your app target, go to General > Frameworks, Libraries, and Embedded Content and add `LoadifyEngine.framework`.
3. In Build Phases > Target Dependencies, add the `LoadifyEngine` target.
4. Ensure the framework is embedded and signed (Embed & Sign).

> Note: LoadifyEngine is no longer distributed as a Swift Package. If you previously used SPM, migrate to one of the options above.

## Quick Start
```swift
import LoadifyEngine

let client = LoadifyClient()

Task {
    do {
        let details = try await client.fetchVideoDetails(for: "https://www.tiktok.com/@user/video/123")
        print("Direct video URL:", details.video.url)
        print("Thumbnail:", details.video.thumbnail)
    } catch {
        print("Failed to fetch details:", error)
    }
}
