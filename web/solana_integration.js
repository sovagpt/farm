// solana_integration.js - Simplified token-only version
// Place this in your project's web directory

class SolanaWallet {
  constructor() {
    this.connected = false;
    this.publicKey = null;
  }

  async connect() {
    try {
      // Check if Phantom wallet exists in the browser
      const { solana } = window;
      
      if (!solana) {
        throw new Error("Please install Phantom wallet extension");
      }
      
      // Connect to wallet
      const response = await solana.connect();
      this.publicKey = response.publicKey.toString();
      this.connected = true;
      
      return {
        success: true,
        publicKey: this.publicKey
      };
    } catch (error) {
      return {
        success: false,
        error: error.message
      };
    }
  }

  async disconnect() {
    try {
      const { solana } = window;
      
      if (solana) {
        await solana.disconnect();
        this.connected = false;
        this.publicKey = null;
      }
      
      return { success: true };
    } catch (error) {
      return {
        success: false,
        error: error.message
      };
    }
  }

  isConnected() {
    return this.connected;
  }

  getPublicKey() {
    return this.publicKey;
  }
}

class TokenManager {
  constructor(wallet) {
    this.wallet = wallet;
    this.tokenMint = null; // Your token mint address
  }

  async setupToken(mintAddress) {
    this.tokenMint = mintAddress;
  }

  async getTokenBalance() {
    try {
      if (!this.wallet.isConnected()) {
        throw new Error("Wallet not connected");
      }
      
      // This is a simplified example - you'd need to use @solana/web3.js to get actual balance
      const connection = new window.solanaWeb3.Connection(
        "https://api.mainnet-beta.solana.com"
      );
      
      // Get token accounts for this wallet
      const tokenAccounts = await connection.getParsedTokenAccountsByOwner(
        new window.solanaWeb3.PublicKey(this.wallet.getPublicKey()),
        { mint: new window.solanaWeb3.PublicKey(this.tokenMint) }
      );
      
      if (tokenAccounts.value.length === 0) {
        return 0;
      }
      
      // Get balance of first account that matches our mint
      const balance = tokenAccounts.value[0].account.data.parsed.info.tokenAmount.uiAmount;
      return balance;
    } catch (error) {
      console.error("Error getting token balance:", error);
      return 0;
    }
  }

  async mintTokensToPlayer(amount) {
    // This would require your backend with proper authority over the mint
    // For demo purposes only
    console.log(`Would mint ${amount} tokens to ${this.wallet.getPublicKey()}`);
    return {
      success: true,
      message: `Minted ${amount} tokens (simulated)`
    };
  }
}

// Main integration class to be used by the game
class SolanaGameIntegration {
  constructor() {
    this.wallet = new SolanaWallet();
    this.tokenManager = new TokenManager(this.wallet);
    this.gameState = {
      playerTokens: 0
    };
  }

  async initialize(tokenMintAddress) {
    await this.tokenManager.setupToken(tokenMintAddress);
  }

  async connectWallet() {
    const result = await this.wallet.connect();
    if (result.success) {
      // After connecting, update game state
      this.gameState.playerTokens = await this.tokenManager.getTokenBalance();
    }
    return result;
  }

  async disconnectWallet() {
    return await this.wallet.disconnect();
  }

  async rewardTokens(amount) {
    const result = await this.tokenManager.mintTokensToPlayer(amount);
    if (result.success) {
      this.gameState.playerTokens += amount;
    }
    return result;
  }

  getGameState() {
    return this.gameState;
  }
}

// Export the main class to be used by the game
window.SolanaGameIntegration = SolanaGameIntegration;