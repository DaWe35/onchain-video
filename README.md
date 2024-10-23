# Onchain Video

Upload and watch videos on the Blast EVM blockchain.

No logical reason to do this.

## Try

https://onchainvideo.win

## Development

Start local development server:

```
npm install
npm run dev
```

Access the development server at: http://localhost:5000

## Production Deployment

This project is set up for deployment using Docker Compose with Node.js 20 and Express.js. Follow these steps:

1. Ensure you have Docker and Docker Compose installed on your production server.
2. Clone this repository to your server.
3. Navigate to the project directory.
4. Run the following command to start the application:

   ```
   docker compose up -d
   ```

   This will start the application in detached mode.

5. Your application will be available on port 80 of your server.

To stop the application, run:

```
docker compose down
```

> Note: Make sure your smart contract addresses and other configuration are set correctly for the production environment.

FFmpeg:

```
ffmpeg -i input.mp4 -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -c:v libx264 -profile:v main -level:v 4.2 -c:a aac -b:a 128k -shortest -movflags frag_keyframe+empty_moov+default_base_moof -f mp4 output_fragmented.mp4
```
> Btw FFmpeg wasm is awesome, I promise I'll use it in a real project. I missed you guys so much
