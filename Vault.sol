// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// QUESTO CONTRATTO È VULNERABILE. NON USARLO.
contract Vault {
    address public admin;
    // NOTA: Il balance del vault è implicito a sé, non è una variabile

    // Viene chiamata una sola volta, quando Vault viene deployato
    constructor() payable {
        admin = msg.sender;
    }

    // Permette a chiunque di depositare soldi nel saldo di questo vault.
    // - L'attributo `payable` permette all'utente di allegare soldi quando chiama questa funzione
    // - L'attributo `external` indica che non può essere chiamata solo da utenti o altri contratti
    receive() external payable {
        // I soldi vengono accettati in automatico; questa funzione è no-op.
    }

    // Trasferisce l'intero saldo del contratto ad un altro indirizzo.
    //
    // Questa funzione è riservata all'admin del Vault (chi l'ha deployato)
    function admin_transferAllFundsTo(address payable _to) public {
    
		// VULNERABILE
        // Questo permette ad un contratto middleman di ereditare i permessi di `tx.origin`!
        require(tx.origin == admin, "Error: Caller is not the owner");

        uint256 vaultBalance = address(this).balance;
        (bool sent, ) = _to.call{value: vaultBalance}("");
        require(sent, "Failed to send Ether");
    }
}
