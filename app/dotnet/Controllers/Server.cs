using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;

namespace dotnet.Controllers
{
    [ApiController]
    public class ServerController : ControllerBase
    {
        [HttpGet]
        [Route("index.html")]
        public IActionResult index()
        {
            return Ok($"Saludos desde el entorno [Development]!\n");
        }

        ///
        /// Test 3
        ///
        [HttpGet]
        [Route("/saludos")]
        public IActionResult saludos([FromServices] IMemoryCache cacheService)
        {
            return Ok(cacheService.Get("mot"));
        }

        ///
        /// Test 4
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
