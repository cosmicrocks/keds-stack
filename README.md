# Knots Electrs Datum Specter/Sparrow (KEDS)

KEDS is a cohesive stack of Bitcoin infrastructure components. It bundles essential services (Knots, Electrs, DATUM, and a choice of Specter or Sparrow Wallet) for interacting with the Bitcoin network, serving wallet requests, and enabling efficient solo mining.

## Why KEDS?

*   **Integrated Solution:** Provides a pre-configured set of compatible components, simplifying the setup of essential Bitcoin infrastructure.
*   **Performance & Efficiency:** Leverages Bitcoin Knots for its optimizations and ElectRS for efficient wallet queries. Includes DATUM for optimized solo mining block template creation.
*   **Wallet Choice:** Integrates with popular desktop wallets like Specter and Sparrow for user-friendly transaction and hardware wallet management.

## Components

KEDS is composed of the following key components:

*   **[Bitcoin Knots](https://bitcoinknots.org/)**: A full node implementation of the Bitcoin protocol. It is based on Bitcoin Core but includes various enhancements and features aimed at improving performance and robustness. Knots handles the core blockchain data synchronization and validation.

*   **[ElectRS (Electrum Rust Server)](https://github.com/romanz/electrs)**: An efficient implementation of the Electrum Server protocol. ElectRS indexes the Bitcoin blockchain maintained by Knots, allowing Electrum-compatible wallets to quickly query blockchain information (addresses, transactions, balances) without needing a full node themselves.

*   **[DATUM Gateway](https://github.com/datum-project/datum)**: The DATUM Gateway implements lightweight, efficient, client-side decentralized block template creation. This allows for true solo mining by constructing block templates directly, reducing reliance on traditional mining pool infrastructure for this task.

*   **Wallet Interface (Specter/Sparrow)**: Provides a user-friendly graphical interface for managing Bitcoin funds, transactions, and hardware wallets. KEDS includes Specter Desktop by default, but can be easily configured to work with Sparrow Wallet.
    *   **[Specter Desktop](https://specter.solutions/)**: Included in the default `docker-compose.yaml`. Focuses on hardware wallet interaction and multisignature setups.
    *   **[Sparrow Wallet](https://sparrowwallet.com/)**: An alternative desktop wallet focusing on transaction control, privacy, and hardware wallet support. Requires manual configuration to connect to the KEDS ElectRS instance.

## Prerequisites

Before deploying KEDS, ensure you have the following:

*   Docker installed.
*   Sufficient disk space for the Bitcoin blockchain (~800GB+).
*   Adequate CPU and RAM resources (vary depending on usage, but recommend at least 4GB RAM and 2+ CPU cores).

## Quick Start / Installation

```
docker-compose up -d
```
