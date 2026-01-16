---
name: video-frame-text
description: Extract a single frame from a video using ffmpeg and add text overlay. Use when the user wants to capture a screenshot/frame from a video file and optionally add text/captions/watermarks to the resulting image. Triggers include "extract frame", "video screenshot", "capture frame from video", "add text to video frame", or working with video thumbnails.
---

# Video Frame Text Extraction

Extract a frame from video and add text overlay using ffmpeg.

## Extract Frame

```bash
ffmpeg -ss <timestamp> -i <input_video> -frames:v 1 -q:v 2 <output.jpg>
```

- `-ss <timestamp>`: Time position (e.g., `00:01:30` or `90` for 90 seconds)
- `-frames:v 1`: Extract single frame
- `-q:v 2`: High quality (1-31, lower is better)

## Add Text Overlay

```bash
ffmpeg -i <input_image> -vf "drawtext=text='<text>':fontsize=<size>:fontcolor=<color>:x=<x>:y=<y>" <output.jpg>
```

Common positions:
- Center: `x=(w-text_w)/2:y=(h-text_h)/2`
- Bottom center: `x=(w-text_w)/2:y=h-th-20`
- Top left: `x=20:y=20`

Options:
- `fontfile=/path/to/font.ttf`: Custom font
- `fontcolor=white`: Text color (name or hex `0xFFFFFF`)
- `fontsize=48`: Font size in pixels
- `borderw=2:bordercolor=black`: Text outline

## Combined: Extract Frame + Add Text

```bash
ffmpeg -ss <timestamp> -i <input_video> -frames:v 1 -vf "drawtext=text='<text>':fontsize=48:fontcolor=white:borderw=2:bordercolor=black:x=(w-text_w)/2:y=h-th-40" -q:v 2 <output.jpg>
```

## Notes

- Escape special characters in text: use `\:` for colon, `\\` for backslash
- For text with spaces, wrap in single quotes
- Supported output formats: jpg, png, bmp, webp
