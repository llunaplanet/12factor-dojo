using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Distributed;
namespace dotnet.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MasunoController : ControllerBase
    {
        private readonly IDistributedCache distributedCache;
        public MasunoController(IDistributedCache distributedCache)
        {
            this.distributedCache = distributedCache;
        }

        [HttpGet]
        public string Get()
        {
            int masuno = 0;
            Int32.TryParse(distributedCache.GetString("masuno"), out masuno);
            masuno++;
            distributedCache.SetString("masuno", masuno.ToString());
            return $"Contador: {masuno}";
        }
    }
}
