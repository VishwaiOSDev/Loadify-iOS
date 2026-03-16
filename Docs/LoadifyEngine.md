# LoadifyEngine

LoadifyEngine is a lightweight Swift framework for extracting downloadable video metadata from popular social platforms.

Given a post URL from platforms like **TikTok, Instagram, Facebook, LinkedIn, or X (Twitter)**, LoadifyEngine fetches normalized metadata including:

- 🎥 Direct video URL
- 🖼 Video thumbnail
- 👤 Creator information (if available)
- 🌐 Platform source

This allows developers to easily build **video downloading or media processing features** into their apps without implementing platform-specific scraping logic.

---

# Features

- Automatic platform detection from URL
- Supports multiple social platforms
- Unified response model (`LoadifyResponse`)
- Async/Await API using Swift Concurrency
- Built-in per-platform rate limiting
- Optional mock mode for development and testing

---

# Requirements

| Requirement | Version |
| ----------- | ------- |
| Swift Tools | 6.0     |
| iOS         | 14+     |
| macOS       | 10.15+  |

See your Xcode target settings for deployment details.

---

# Download Framework

Download the latest prebuilt framework:

**[LoadifyEngine.xcframework](https://vishwa.is-a.dev/frameworks/LoadifyEngine.zip)**

After downloading, extract the archive to access the `LoadifyEngine.xcframework`.

---

# Installation

## Use Prebuilt XCFramework (Recommended)

1. Download **LoadifyEngine.xcframework**
2. Open your **Xcode project**
3. Select your **App Target**
4. Go to:

```
General → Frameworks, Libraries, and Embedded Content
```

5. Drag **LoadifyEngine.xcframework** into the section
6. Set the embed option to:

```
Embed & Sign
```

---

# Quick Start

LoadifyEngine automatically detects the platform from the URL and routes the request to the correct extractor internally.

You only need to provide the post URL.

```swift
import LoadifyEngine

let client = LoadifyClient()

Task {
    do {
        let details = try await client.fetchVideoDetails(
            for: "https://www.tiktok.com/@user/video/123"
        )

        print("Platform:", details.platform)
        print("Video URL:", details.video.url)
        print("Thumbnail:", details.video.thumbnail)

    } catch {
        print("Failed to fetch details:", error)
    }
}
```

---

# Smart URL Detection

LoadifyEngine automatically identifies the platform from the provided URL.

| Example URL                   | Detected Platform |
| ----------------------------- | ----------------- |
| `instagram.com/reel/...`      | Instagram         |
| `tiktok.com/@user/video/...`  | TikTok            |
| `facebook.com/.../videos/...` | Facebook          |
| `linkedin.com/posts/...`      | LinkedIn          |
| `x.com/.../status/...`        | X (Twitter)       |

No platform-specific logic is required in your application.

Simply pass the URL and LoadifyEngine will handle the rest.

---

# Mock Mode (Recommended for Development)

LoadifyEngine includes a **mock mode** that prevents API calls to servers.

This is useful during development or when running UI demos.

```swift
let client = LoadifyClient(isMockEnabled: true)
```

Mock mode allows you to test your integration without hitting real APIs.

---

# Production Usage

For production builds, disable mock mode:

```swift
let client = LoadifyClient(isMockEnabled: false)
```

> It is highly recommended to enable mock mode during development and disable it only for production.

---

# Supported Platforms

LoadifyEngine currently supports:

- Instagram
- TikTok
- Facebook
- LinkedIn
- X (Twitter)

Additional platforms may be added in future releases.

---

# Contributing

If you're building something cool using **LoadifyEngine**, feel free to share it with the community.

You can also:

- Open issues for feature requests
- Submit pull requests
- Join the Loadify community

---
