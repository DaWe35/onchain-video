// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract OnchainVideo {
    struct VideoChunk {
        bytes data;
        address owner;
    }

    struct PlaylistItem {
        string filename;
        uint256 duration;  // Changed from length to duration
        string metadata;
        uint256[] chunkIds;
    }

    mapping(uint256 => VideoChunk) public chunks;
    uint256 public nextChunkId;

    mapping(address => PlaylistItem[]) public userPlaylists;

    event PlaylistCreated(address indexed user, uint256 playlistIndex);
    event ChunkAdded(uint256 chunkId, address indexed owner, uint256 playlistIndex);

    function createPlaylist(string memory _filename, uint256 _duration, string memory _metadata) public returns (uint256) {
        PlaylistItem memory newPlaylist = PlaylistItem({
            filename: _filename,
            duration: _duration,  // Changed from length to duration
            metadata: _metadata,
            chunkIds: new uint256[](0)
        });

        userPlaylists[msg.sender].push(newPlaylist);
        uint256 newPlaylistIndex = userPlaylists[msg.sender].length - 1;
        
        emit PlaylistCreated(msg.sender, newPlaylistIndex);
        return newPlaylistIndex;
    }

    function addChunk(bytes memory _data, uint256 _playlistIndex) public returns (uint256) {
        require(_playlistIndex < userPlaylists[msg.sender].length, "Playlist does not exist");

        uint256 chunkId = nextChunkId++;
        chunks[chunkId] = VideoChunk(_data, msg.sender);

        userPlaylists[msg.sender][_playlistIndex].chunkIds.push(chunkId);

        emit ChunkAdded(chunkId, msg.sender, _playlistIndex);
        return chunkId;
    }

    function getPlaylistCount(address _user) public view returns (uint256) {
        return userPlaylists[_user].length;
    }

    function getPlaylist(address _user, uint256 _playlistIndex) public view returns (
        string memory filename,
        uint256 duration,  // Changed from length to duration
        string memory metadata,
        uint256[] memory chunkIds
    ) {
        require(_playlistIndex < userPlaylists[_user].length, "Playlist does not exist");
        PlaylistItem storage playlist = userPlaylists[_user][_playlistIndex];
        return (playlist.filename, playlist.duration, playlist.metadata, playlist.chunkIds);
    }

    function getChunk(uint256 _chunkId) public view returns (bytes memory) {
        return chunks[_chunkId].data;
    }
}