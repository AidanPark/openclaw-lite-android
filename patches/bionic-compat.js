/**
 * bionic-compat.js - Android Bionic libc compatibility shim
 *
 * Loaded via NODE_OPTIONS="-r <path>/bionic-compat.js"
 *
 * Wraps os.networkInterfaces() in a try-catch to prevent crashes
 * caused by Android Bionic's limited getifaddrs() implementation.
 */

'use strict';

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
