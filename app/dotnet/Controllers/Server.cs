using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Http;
using dotnet.Services;
using ServiceStack.Redis;

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
        [HttpGet]
        [Route("masuno")]
        public IActionResult masuno([FromServices] RedisClient redisClient)
        {
            int masuno = 0;
            Int32.TryParse(redisClient.Get<string>("masuno"), out masuno);
            masuno++;
            redisClient.Set<string>("masuno", masuno.ToString());

            return Ok($"Contador: {masuno}");
        }

        [HttpGet]
        [Route("index.html")]
        public IActionResult index([FromServices] IConfiguration configuration)
        {
            string entorno = configuration.GetValue<string>("Entorno");
            return Ok($"Saludos desde el entorno [{entorno}]!\n");
        }

        [HttpGet]
        [Route("/diminombre")]
        public IActionResult diminombre(string nombre)
        {

            Response.Cookies.Append("connect.sid", nombre, new CookieOptions() { Path = "/" });
            return Ok($"Hola {nombre}, encantado de conocerte");
        }

        [HttpGet]
        [Route("/quiensoy")]
        public IActionResult quiensoy()
        {
            string nombre = Request.Cookies.ContainsKey("connect.sid") ? Request.Cookies["connect.sid"] : "sin nombre";
            return Ok(nombre);
        }

        [HttpGet]
        [Route("dameun500")]
        public IActionResult dameun500()
        {
            throw new Exception("Toma un 500!");
        }

        [HttpGet]
        [Route("/encolame")]
        public IActionResult encolame([FromServices] IQueueService queueService)
        {
            if (queueService.Publish("foo", "Hello World!"))
            {
                return Ok("Mensaje enviado a la cola");
            }
            return StatusCode(503, "Servicio no disponible");
        }
    }
}
