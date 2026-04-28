using Ocelot.DependencyInjection;
using Ocelot.Middleware;
using Ocelot.Provider.Consul;
using BaseApi.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Load Ocelot Configuration
builder.Configuration.AddJsonFile($"ocelot.{builder.Environment.EnvironmentName}.json", optional: false, reloadOnChange: true);

// Add Ocelot and Consul
builder.Services.AddOcelot(builder.Configuration)
    .AddConsul();

// Add BaseInfrastructure (Health checks, etc. from BaseApi submodule)
builder.Services.AddBaseInfrastructure(builder.Configuration);

// Add Consul Config
builder.Services.AddConsulConfig(builder.Configuration);

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseBaseInfrastructure("Gateway API", "Gateway API - Ocelot Gateway");

// Register with Consul
app.RegisterWithConsul(builder.Configuration, app.Lifetime);

// Use Ocelot
await app.UseOcelot();

app.Run();
