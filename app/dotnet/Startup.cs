using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Caching.Memory;

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

            ///
            /// Test 4
            ///
            ///
            /// Test 4
            ///

            ///
            /// Test 6
            ///
            ///
            /// Test 6
            ///

            ///
            /// Test 11
            ///
            ///
            /// Test 11
            ///

            ///
            /// Test 9
            ///
            ///
            /// Test 9
            ///
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IMemoryCache cache)
        {
            cache.Set("mot", "Chee nano!");

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            ///
            /// Test 11
            ///
            ///
            /// Test 11
            ///

            ///
            /// Test 6
            ///
            ///
            /// Test 6
            ///
            
            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
