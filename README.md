# ⚠️ `tx-origin-misuse`

This repository is meant to showcase how an incorrect usage of the `tx.origin` variable can enable an unexpected privilege escalation vulnerability and open the doors to social engineering attacks.

> [!CAUTION]
> This should be obvious enough, but **please don’t use any of this code in any real-world application!**
> 
> **`Vault.sol` is a DELIBERATELY VULNERABLE CONTRACT and should NEVER be used outside of a purely educational context**.
> 
> If you do so, it’s *completely* on you.

## Attack

### Initial situation

1. Victim deploys a `Vault` contract thus becoming its **admin**.
2. Anyone can deposit money on the `Vault`, but only the **admin** can transfer them out of it to anywhere they want, by checking `tx.origin` (the call chain’s root) is the admin user.

### How the attack works

1. The attacker deploys an evil `Middleman` contract interfacing with the victim’s `Vault`
2. The `Middleman` contract has a public function that the attacker will trick the victim into calling. This function calls the admin-only function to exfiltrate the vault’s balance to an address they control (such as... themselves).
3. By doing so, the victim will start a transaction of which they are the `tx.owner` of.
4. The vulnerable `Vault` doesn’t check who is calling (the middleman) and only checks who begun the call chain (the victim).
5. The victim has admin permissions so the vault performs the request.

## Getting started

It’s best to test this on a **local Ethereum testnet**, such as [Anvil](https://getfoundry.sh/anvil/overview/).

You may run **Anvil** easily by using:

```bash
$ curl -L https://foundry.paradigm.xyz | bash
$ anvil --chain-id 1337 --accounts 2
```

#### If you have Docker

This repository contains a `docker-compose.yml` file with a configured Anvil instance.

**To get started, run**:

```bash
$ git clone https://github.com/zephyrcodesstuff/tx-origin-misuse
$ cd tx-origin-misuse
$ docker compose up
```

> [!NOTE]
> **Your instance is now available** at `http://127.0.01:8545`.

### Configuring Remix IDE to use your instance

[Remix IDE](https://remix.ethereum.org) is a convenient environment to test your contracts and perform transactions without writing code, using a GUI.

> [!TIP]
> I recommend **downloading Remix Desktop and running it locally**, instead of using the website, as it may not connect right away to your localhost instance, due to web browser sandboxing shenanigans.

1. On the left, open the **fourth (4th) tab**, named: “Deploy & run transactions”.
2. At the top, **click on “Remix VM (?)”** and **change it to** the last option, “**Dev - Foundry Provider**”.
3. Accept the default URL (or paste this one in): `http://127.0.0.1:8545`

Now you’re ready to deploy contracts, perform transactions and call functions!