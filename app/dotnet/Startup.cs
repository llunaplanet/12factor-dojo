using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Caching.Memory;
using System.Text.RegularExpressions;

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
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IMemoryCache cache)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            
            //app.UseHttpsRedirection();
            cache.Set("mot", Environment.GetEnvironmentVariable("MOT"));
            
            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
