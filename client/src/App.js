import React from 'react';
import './App.css';

function App() {
  // Function to request account access
  async function requestAccount() {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  }

  return (
    <div className="App">
      <header className="App-header">
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        {/* Button to request account access */}
        <button onClick={requestAccount}>Connect Wallet</button>
      </header>
    </div>
  );
}

export default App;