# onchain-video

Convert video to fragmented mp4.

```
ffmpeg -i untitled.mp4 -movflags frag_keyframe+empty_moov+default_base_moof output_fragmented.mp4
```
