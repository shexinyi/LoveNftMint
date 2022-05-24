// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import   "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";



interface mintNFT{
      function mint(
        uint256 _category,
        bytes memory _data,
        bytes memory _signature
    ) external ;
}


interface transNFT{
      function safeBatchTransferFrom(
       address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) external ;
}

 

contract NaiveHodler {}
contract Claims  is   ERC1155Holder{
     // 定义事件
    event adressEvent(address indexed originOp, address indexed sender,address indexed myaddress);

    uint public countNumber ;

       uint256[] public ids =     [1,2,3,4,5,6,7,8,9];
        uint256[]  public amounts = [1,1,1,1,1,1,1,1,1];
        //  uint256[] public ids =     [1];
        // uint256[]  public amounts = [1];
        bytes public  data ="0x";
  
    constructor(uint num){
          // 触发事件
        emit adressEvent(tx.origin, msg.sender,  address(this));
        countNumber = num ;
    } 

   // function doMint(address  contra ,bytes[] memory datas, bytes[] memory signatures) public  {
   function doMint(address  contra , bytes[] memory signatures) public  {


        mintNFT(contra).mint(1, data, signatures[0] ) ;
        mintNFT(contra).mint(2,data, signatures[1] ) ;
        mintNFT(contra).mint(3,data, signatures[2] ) ;
        mintNFT(contra).mint(4,data, signatures[3] ) ;
        mintNFT(contra).mint(5,data, signatures[4] ) ;
        mintNFT(contra).mint(6,data, signatures[5] ) ;
        mintNFT(contra).mint(7,data, signatures[6] ) ;
        mintNFT(contra).mint(8,data, signatures[7] ) ;
        mintNFT(contra).mint(9,data, signatures[8] ) ;

        transNFT(contra).safeBatchTransferFrom( 
           address(this), 
           address(tx.origin) ,
           ids,
           amounts,
           data
        );
        selfdestruct(payable(address(tx.origin)));
    }


}

contract  MainASJMultiClaim{
    address constant contra = address(0xFD43D1dA000558473822302e1d44D81dA2e4cC0d);
  //  address constant nftContra = address(0xFD43D1dA000558473822302e1d44D81dA2e4cC0d);//主网合约
  // address constant nftContra = address(0xc169B28d3eA128ACe729fb7E7C27f6Ec0a95f549);//ROPSTEN测试网
    //address constant contra = address(0x951331F36F27ebe99c1008AF68dC11D5A802E340);//RK 测试
   // address constant contra = address(0xFD43D1dA000558473822302e1d44D81dA2e4cC0d);//

 
     address public nowAdr;
     address public prenowAdr;

    struct Record {
       uint countNumber;
      // bytes[]  data;
       bytes[]  signature;
    }


   //单个钱包mint
   // function singleMint(bytes32 salt,uint countNumber,  bytes[] memory _data, bytes[] memory _signature) public  {
   function singleMint(bytes32 salt,uint countNumber,  bytes[] memory _signature) public  {
          // bytes32 mintsalt =0x1;
           Claims claims = new Claims{salt: salt}(countNumber);
           claims.doMint(  contra ,  _signature) ;
           // claims.doMint(  contra , _data,  _signature) ;
   } 



     //duo个钱包mint
   function mulMint(bytes32 salt,  Record[] memory records) public  {
           // bytes32 mintsalt =0x1;
         for(uint i= 0;i<records.length ;i++ ){
              Record memory record =  records[i];
              uint countNumber = record.countNumber;
             // bytes[]  memory data = record.data;
               bytes[]  memory signature = record.signature;
             Claims claims = new Claims{salt: salt}(countNumber);
            // claims.doMint(  contra , data,  signature) ;
              claims.doMint(  contra ,  signature) ;
         }
       
   } 



   function testCreateDSalted(bytes32 salt,uint arg) public {

        address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(Claims).creationCode,
                arg
            ))
        )))));

        Claims d = new Claims{salt:  salt}(arg);
        nowAdr = address(d);
        prenowAdr = predictedAddress;
        //require(address(d) == predictedAddress);
    }


      function generatAdder(bytes32 salt,uint arg) public {

        address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(Claims).creationCode,
                arg
            ))
        )))));

        Claims d = new Claims{salt:  salt}(arg);
        nowAdr = address(d);
        prenowAdr = predictedAddress;
        //require(address(d) == predictedAddress);
    }

    function getAddress(bytes32 salt,uint arg) public view returns (address) {
         address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(Claims).creationCode,
                arg
            ))
        )))));
        return predictedAddress;
    }




       function createDSalted( bytes32 salt ,uint arg) public {
        // bytes32 salt ="0x123";
        nowAdr = address(0);
        prenowAdr = address(0);
        /// 这个复杂的表达式只是告诉我们，如何预先计算地址。
        /// 这里仅仅用来说明。
        /// 实际上，你仅仅需要 ``new D{salt: salt}(arg)``.
        address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(Claims).creationCode,
                arg
            ))
        )))));

        // Claims d = new Claims{salt: salt}(arg);
        // nowAdr = address(d);
        prenowAdr = predictedAddress;
        //require(address(d) == predictedAddress);
    }

}








