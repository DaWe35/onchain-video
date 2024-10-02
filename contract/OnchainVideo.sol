// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IBlast {
    function configureAutomaticYield() external;
    function configureClaimableGas() external;
    function configureGovernor(address governor) external;
}

interface IBlastPoints {
  function configurePointsOperator(address operator) external;
}

contract OnchainVideo is Ownable {
    struct VideoChunk {
        bytes data;
        address owner;
    }

    struct Video {
        string filename;
        uint256 duration;
        string metadata;
        uint256[] chunkIds;
        address owner;
    }

    mapping(uint256 => VideoChunk) public chunks;
    uint256 public nextChunkId;

    mapping(uint256 => Video) public videos;
    uint256 public nextVideoId;

    mapping(address => uint256[]) public userVideoIds;

    event VideoCreated(address indexed user, uint256 videoId);
    event ChunkUploaded(uint256 chunkId, address indexed owner, uint256 videoId);

    IBlast public constant BLAST = IBlast(0x4300000000000000000000000000000000000002);

    constructor() Ownable(msg.sender) {
        BLAST.configureAutomaticYield();
        BLAST.configureClaimableGas();
        // the governor is set, this contract will lose the ability to configure itself.
        BLAST.configureGovernor(msg.sender);

        // BlastPoints Testnet address: 0x2fc95838c71e76ec69ff817983BFf17c710F34E0
        // BlastPoints Mainnet address: 0x2536FE9ab3F511540F2f9e2eC2A805005C3Dd800
        IBlastPoints(0x2536FE9ab3F511540F2f9e2eC2A805005C3Dd800).configurePointsOperator(msg.sender);
    }

    receive() external payable {}

    function createOnchainVideo(string memory _filename, uint256 _duration, string memory _metadata) public returns (uint256) {
        uint256 videoId = nextVideoId++;
        Video storage newVideo = videos[videoId];
        newVideo.filename = _filename;
        newVideo.duration = _duration;
        newVideo.metadata = _metadata;
        newVideo.owner = msg.sender;

        userVideoIds[msg.sender].push(videoId);
        
        emit VideoCreated(msg.sender, videoId);
        return videoId;
    }

    function uploadChunk(bytes memory _data, uint256 _videoId) public returns (uint256) {
        require(videos[_videoId].owner == msg.sender, "Not the video owner");

        uint256 chunkId = nextChunkId++;
        chunks[chunkId] = VideoChunk(_data, msg.sender);

        videos[_videoId].chunkIds.push(chunkId);

        emit ChunkUploaded(chunkId, msg.sender, _videoId);
        return chunkId;
    }

    function getVideoCount(address _user) public view returns (uint256) {
        return userVideoIds[_user].length;
    }

    function getVideoIds(address _user) public view returns (uint256[] memory) {
        return userVideoIds[_user];
    }

    function getVideo(uint256 _videoId) public view returns (
        string memory filename,
        uint256 duration,
        string memory metadata,
        uint256[] memory chunkIds,
        address owner
    ) {
        Video storage video = videos[_videoId];
        require(video.owner != address(0), "Video does not exist");
        return (video.filename, video.duration, video.metadata, video.chunkIds, video.owner);
    }

    function getChunk(uint256 _chunkId) public view returns (bytes memory) {
        return chunks[_chunkId].data;
    }

    function withdrawETH() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH balance to withdraw");
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "ETH transfer failed");
    }

    function withdrawToken(address _token) external onlyOwner {
        require(_token != address(0), "Invalid token address");
        IERC20 token = IERC20(_token);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No token balance to withdraw");
        require(token.transfer(msg.sender, balance), "Token transfer failed");
    }
}