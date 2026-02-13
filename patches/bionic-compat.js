/**
 * bionic-compat.js - Android Bionic libc compatibility shim
 *
 * Loaded via NODE_OPTIONS="-r <path>/bionic-compat.js"
 *
 * Wraps os.networkInterfaces() in a try-catch to prevent crashes
 * caused by Android Bionic's limited getifaddrs() implementation.
 */

'use strict';

// Override process.platform from 'android' to 'linux'
// Termux runs on Linux kernel but Node.js reports 'android',
// causing OpenClaw to reject the platform as unsupported.
Object.defineProperty(process, 'platform', {
  value: 'linux',
  writable: false,
  enumerable: true,
  configurable: true,
});

const os = require('os');

const _originalNetworkInterfaces = os.networkInterfaces;

os.networkInterfaces = function networkInterfaces() {
  try {
    return _originalNetworkInterfaces.call(os);
  } catch {
    return {
      lo: [
        {
          address: '127.0.0.1',
          netmask: '255.0.0.0',
          family: 'IPv4',
          mac: '00:00:00:00:00:00',
          internal: true,
          cidr: '127.0.0.1/8',
        },
      ],
    };
  }
};
