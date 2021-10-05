## Setup instructions

This sample demonstrates how to configure **HTTP/3** in an ASP.NET application running on **.NET 6.0** and using **Let's Encrypt** to negotiate a certificate on startup.

It uses a Linux only Docker image to demonstrate the usage of `libmsquic`.

### Build an image named 'http3' from local Docker file
`sudo docker build -t http3 .`

### Run new container named 'http3' and expose all ports to the local interface
`sudo docker run --name http3 -d --network host http3`

### Troubleshooting

- Check your browser supports HTTP/3. For Microsoft Edge use the setting `edge://flags/#enable-quic`
- Modify the `appsettings.json` file with the domain to negotiate for the certificate.
