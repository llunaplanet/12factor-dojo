using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace dotnet
{
    public class Program
    {
        public static void Main(string[] args)
        {
            if (Environment.GetEnvironmentVariable("ENVIRONMENT") != null)
            {
                Environment.SetEnvironmentVariable("ASPNETCORE_ENVIRONMENT", Environment.GetEnvironmentVariable("ENVIRONMENT"));
            }
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {


                    webBuilder.UseUrls($"http://*:{Environment.GetEnvironmentVariable("PORT") ?? "8080"}");
                    webBuilder.UseStartup<Startup>();
                });
    }
}
