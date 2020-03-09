using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Caching.Memory;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Http;
using NATS.Client;

namespace dotnet
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {

            services.AddControllers();
            services.AddMemoryCache();

            services.AddDistributedRedisCache(option =>
            {
                string connectionStringRedis = Environment.GetEnvironmentVariable("REDIS_URI") ?? String.Empty;
                Regex regex = new Regex(@"redis://:(?<password>[\w\-]+)@(?<server>[\w\-]+)/", RegexOptions.None);
                Match match = regex.Match(connectionStringRedis);
                if (match.Success)
                {
                    string server = match.Result("${server}");
                    string password = match.Result("${password}");

                    option.Configuration = $"{server},password={password}";
                }
            });
            services.AddTransient<IConnection>(s =>
            {
                try
                {                    
                    ConnectionFactory factory = new ConnectionFactory();
                    var options = ConnectionFactory.GetDefaultOptions();
                    options.Url = Environment.GetEnvironmentVariable("NATS_URI");
                    options.MaxReconnect = -1;
                    options.ReconnectWait = 250;
                    options.AllowReconnect = true;

                    return factory.CreateConnection(options);
                }
                catch
                {
                    return null;
                }
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IMemoryCache cache)
        {
            string entorno = Configuration.GetValue<string>("Entorno");
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            // else
            // {
            //     app.UseExceptionHandler("error");
            // }

            cache.Set("mot", Environment.GetEnvironmentVariable("MOT"));

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapGet("index.html", new RequestDelegate(res => res.Response.WriteAsync($"Saludos desde el entorno [{entorno}]!\n")));
            });
        }
    }
}
