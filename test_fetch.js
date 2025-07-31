// TEST DI CHROME DEVTOOLS CONSOLE
// Buka Chrome DevTools (F12) di aplikasi Flutter
// Paste code berikut di Console dan tekan Enter

console.log("Testing fetch from browser...");

fetch('http://localhost:8080/api/admin/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-DEVICE-ID': 'browser-test',
    'X-DEVICE-NAME': 'Chrome DevTools',
    'X-DEVICE-OS': 'Web',
    'X-DEVICE-OS-VERSION': '1.0',
    'X-DEVICE-OS-VERSION-CODE': '1.0'
  },
  body: JSON.stringify({
    email: 'admin@mbankingcore.com',
    password: 'admin123'
  })
})
.then(response => {
  console.log('Response status:', response.status);
  console.log('Response ok:', response.ok);
  return response.json();
})
.then(data => {
  console.log('Success:', data);
})
.catch(error => {
  console.error('Error:', error);
});
