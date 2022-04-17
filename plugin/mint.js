export const ADDR = '0x14Eeb87a01a4D5320152a058Ca0ce3Ae94F1129c';

export const ABI = [
	{
		"constant": false,
		"inputs": [
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
		"name": "mint",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "nft",
				"type": "address"
			},
			{
				"internalType": "address",
				"name": "util",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	}
];