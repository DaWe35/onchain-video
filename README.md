# onchain-video

Start local server:

```
npm install -g 
serve -l 5000 --cors
http://localhost:5000
```

FFmpeg:

```
ffmpeg -i input.mp4 -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -c:v libx264 -profile:v main -level:v 4.2 -c:a aac -b:a 128k -shortest -movflags frag_keyframe+empty_moov+default_base_moof -f mp4 output_fragmented.mp4
```