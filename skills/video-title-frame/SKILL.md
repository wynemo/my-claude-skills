---
name: video-title-frame
description: Insert a title frame (thumbnail with text overlay) as the first frame of a video without affecting video duration or subtitle timing. Use when the user wants to add a title card, cover frame, or thumbnail to the beginning of a video. Triggers include "insert title frame", "add cover to video", "add first frame", "插入第一帧", "加入封面帧", "标题帧".
---

# Video Title Frame Insertion

Insert a title frame at the beginning of a video. The title frame occupies only 1 frame (≈16ms), so it does NOT affect video duration or subtitle timing.

## Workflow

### Step 0: Probe original video parameters

Use `ffprobe` to get fps, resolution, audio sample rate, channel layout, and **video timescale (time_base)**:

```bash
ffprobe -v quiet -print_format json -show_streams <input_video>
```

Key values to extract:
- Video: `r_frame_rate`, `width`x`height`, `time_base` (e.g., 1/19200 → timescale=19200)
- Audio: `sample_rate`, `channel_layout` (e.g., 24000, mono)

### Step 1: Generate thumbnail with text overlay

Extract the first frame and add text using drawtext filters (refer to video-frame-text skill for text overlay details).

```bash
ffmpeg -ss 0 -i <input_video> -frames:v 1 -vf "\
drawbox=x=0:y=(ih/2)-<box_y_offset>:w=iw:h=<box_height>:color=white@0.75:t=fill,\
drawtext=text='<text>':fontfile=/System/Library/Fonts/STHeiti\ Medium.ttc:fontsize=<size>:fontcolor=<color>:borderw=<bw>:bordercolor=<bc>:x=<x>:y=<y>" \
-q:v 2 <thumbnail.jpg> -y
```

### Step 2: Create 1-frame title card video with silent audio

CRITICAL: Must use `-video_track_timescale` matching the original video's timescale to avoid duration corruption during concat.

```bash
ffmpeg -loop 1 -i <thumbnail.jpg> \
  -f lavfi -i anullsrc=r=<sample_rate>:cl=<channel_layout> \
  -t 0.0167 \
  -c:v libx264 -profile:v high -pix_fmt yuv420p -r <fps> -s <resolution> \
  -c:a aac \
  -video_track_timescale <timescale> \
  <title_card.mp4> -y
```

Parameters to match from the original video:
- `-r <fps>`: Frame rate (e.g., 60)
- `-s <resolution>`: Resolution (e.g., 3840x2160)
- `-video_track_timescale <timescale>`: **MUST match** original video's timescale (e.g., 19200). Without this, concat will produce incorrect duration!
- `anullsrc=r=<sample_rate>:cl=<channel_layout>`: Match original audio (e.g., r=24000:cl=mono)

### Step 3: Concat title card + original video

No need to trim the original. Just prepend the 1-frame title card:

```bash
# Create concat list
echo "file 'title_card.mp4'
file '<input_video>'" > concat_list.txt

# Concat (stream copy, very fast)
ffmpeg -f concat -safe 0 -i concat_list.txt -c copy <output_video.mp4> -y
```

### Step 4: Verify duration

```bash
ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1 <output_video.mp4>
```

Duration should be ≈ original + 0.017s (1 frame).

## Important Notes

- **`-video_track_timescale` is mandatory** — timescale mismatch between title card and original video causes concat to produce wildly incorrect duration (e.g., 244s → 305s)
- The title frame occupies only 1 frame (≈16ms), does NOT meaningfully affect duration or subtitle timing
- Steps 2-3 use stream copy for the main video, completing in seconds
- Place temporary files (title_card.mp4, concat_list.txt) in the scratchpad directory
- Output file should use `_final` suffix (e.g., `video_final.mp4`)
