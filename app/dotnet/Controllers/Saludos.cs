using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Caching.Memory;

namespace dotnet.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class SaludosController : ControllerBase
    {
        private IMemoryCache cache;
        public SaludosController(IMemoryCache cache)
        {
            this.cache = cache;
        }

        [HttpGet]
        public string Get()
        {
            string saludo = cache.Get("mot")?.ToString() ?? "Hola sin más";
            return saludo;
        }
    }
}
