using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Http;
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
