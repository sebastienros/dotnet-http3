using Microsoft.AspNetCore.Server.Kestrel.Core;
using System.Net;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddLettuceEncrypt();

builder.WebHost.UseKestrel(k =>
{
    var services = k.ApplicationServices;

    k.Listen(IPAddress.Any,
        443,
        listenOptions =>
    {
        // Enables HTTP/3
        listenOptions.Protocols = HttpProtocols.Http1AndHttp2AndHttp3;

        // Adds a TLS certificate to the endpoint
        listenOptions.UseHttps(httpsOptions =>
        {
            httpsOptions.UseLettuceEncrypt(services);
        });
    });
});

var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.Run();
