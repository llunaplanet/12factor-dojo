using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Caching.Memory;
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Http;
using ServiceStack.Redis;
using dotnet.Services;
using Microsoft.AspNetCore.Diagnostics;

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

            services.AddSingleton<RedisClient>(ser => 
            {
                string connectionStringRedis = Environment.GetEnvironmentVariable("REDIS_URI") ?? String.Empty;
                Regex regex = new Regex(@"redis://(?<password>:[\w\-]+@)*(?<server>[\w\-]+)(?<port>:[\d]+)*/");
                Match match = regex.Match(connectionStringRedis);
                if (match.Success)
                {
                    string server = match.Result("${server}");
                    string password = string.IsNullOrEmpty(match.Result("${password}")) ? "" : match.Result("${password}")[1..^1];
                    int port = string.IsNullOrEmpty(match.Result("${port}")) ? 6379 : Int32.Parse(match.Result("${port}")[1..]);
                    return new RedisClient(server, port, password);
                }
                return new RedisClient();
            });
            
            services.AddSingleton<IQueueService, QueueService>();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IMemoryCache cache)
        {
            app.UseExceptionHandler(errorHandler => 
            {
                errorHandler.Run(async context =>
                {
                    var ex = context.Features.Get<IExceptionHandlerPathFeature>();
                    string error = "Error";

                    if (ex?.Error != null)
                    {
                        error  = ex.Error.Message;
                    }
                    
                    Console.WriteLine(error);
                    context.Response.StatusCode = 500;
                    await context.Response.WriteAsync($"Url: {context.Request.Path}\n");;
                    await context.Response.WriteAsync($"Error: {error}\n");
                });
            });

            cache.Set("mot", "Chee nano!");

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
