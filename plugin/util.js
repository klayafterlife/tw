export const ADDR = '0x70f68EB42809D981F7e74Ed35561ffFD85b5D9C9';

export const ABI = [
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "tokenId",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "back",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "eye",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "body",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "belly",
				"type": "string"
			}
		],
		"name": "change",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	}
];