using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;

namespace dotnet.Controllers
{
    [ApiController]
    public class ServerController : ControllerBase
    {
        ///
        /// Test 3
        ///
        [HttpGet]
        [Route("/saludos")]
        public IActionResult saludos([FromServices] IMemoryCache cacheService)
        {
            string saludo = cacheService.Get("mot")?.ToString() ?? "Hola sin más";
            return Ok(saludo);
        }

        ///
        /// Test 4
        ///

        ///
        /// Test 5
        ///

        ///
        /// Test 6
        ///

        ///
        /// Test 11
        ///

        ///
        /// Test 9
        /// 
    }
}
