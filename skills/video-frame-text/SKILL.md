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

## Chinese Font Support (macOS)

For Chinese text, use these fonts:
- Bold: `/System/Library/Fonts/STHeiti Medium.ttc`
- Regular: `/System/Library/Fonts/Hiragino Sans GB.ttc`

## Add Text Overlay (Single Line)

```bash
ffmpeg -i <input_image> -vf "drawtext=text='<text>':fontfile=/System/Library/Fonts/STHeiti\ Medium.ttc:fontsize=140:fontcolor=black:x=(w-text_w)/2:y=(h-text_h)/2" <output.jpg>
```

Common positions:
- Center: `x=(w-text_w)/2:y=(h-text_h)/2`
- Bottom center: `x=(w-text_w)/2:y=h-th-20`
- Top left: `x=20:y=20`

Options:
- `fontfile=/path/to/font.ttf`: Custom font (escape spaces with `\ `)
- `fontcolor=black` or `fontcolor=white`: Text color
- `fontsize=140`: Font size in pixels (100-150 recommended for titles)
- `borderw=2:bordercolor=black`: Text outline for bolder appearance

## Multi-line Text (Chain drawtext filters)

For long text, split into multiple lines using chained drawtext filters:

```bash
ffmpeg -ss <timestamp> -i <input_video> -frames:v 1 -vf "\
drawtext=text='Line 1':fontfile=/System/Library/Fonts/STHeiti\ Medium.ttc:fontsize=140:fontcolor=black:borderw=2:bordercolor=black:x=(w-text_w)/2:y=(h/2)-210,\
drawtext=text='Line 2':fontfile=/System/Library/Fonts/STHeiti\ Medium.ttc:fontsize=140:fontcolor=black:borderw=2:bordercolor=black:x=(w-text_w)/2:y=(h/2)-35,\
drawtext=text='Line 3':fontfile=/System/Library/Fonts/STHeiti\ Medium.ttc:fontsize=140:fontcolor=black:borderw=2:bordercolor=black:x=(w-text_w)/2:y=(h/2)+140" \
-q:v 2 <output.jpg> -y
```

Vertical spacing guide (for fontsize=140):
- 3 lines centered: y=(h/2)-210, y=(h/2)-35, y=(h/2)+140
- Adjust spacing (~175px between lines) based on font size

## Combined: Extract Frame + Add Text (Simple)

```bash
ffmpeg -ss <timestamp> -i <input_video> -frames:v 1 -vf "drawtext=text='<text>':fontfile=/System/Library/Fonts/STHeiti\ Medium.ttc:fontsize=140:fontcolor=black:borderw=2:bordercolor=black:x=(w-text_w)/2:y=(h-text_h)/2" -q:v 2 <output.jpg> -y
```

## Notes

- Escape special characters in text: use `\:` for colon, `\\` for backslash
- Escape spaces in font paths with `\ `
- For text with spaces, wrap in single quotes
- Use `-y` flag to overwrite existing output file
- Supported output formats: jpg, png, bmp, webp
- For bolder text: use STHeiti Medium + borderw with same color as fontcolor
