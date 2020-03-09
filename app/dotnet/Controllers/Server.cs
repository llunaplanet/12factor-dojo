using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Http;
using dotnet.Services;
using ServiceStack.Redis;

namespace dotnet.Controllers
{
    [ApiController]
    public class ServerController : ControllerBase
    {
        [HttpGet]
        [Route("/saludos")]
        public IActionResult saludos([FromServices] IMemoryCache cacheService)
        {
            try
            {
                string saludo = cacheService.Get("mot")?.ToString() ?? "Hola sin más";
                return Ok(saludo);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Problem(ex.Message);
            }
        }

        [HttpGet]
        [Route("/diminombre")]
        public IActionResult diminombre(string nombre)
        {
            try
            {
                Response.Cookies.Append("connect.sid", nombre, new CookieOptions() { Path = "/" });
                return Ok($"Hola {nombre}, encantado de conocerte");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Problem(ex.Message);
            }
        }

        [HttpGet]
        [Route("/quiensoy")]
        public IActionResult quiensoy()
        {
            try
            {
                string nombre = Request.Cookies.ContainsKey("connect.sid") ? Request.Cookies["connect.sid"] : "sin nombre";
                return Ok(nombre);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Problem(ex.Message);
            }
        }

        [HttpGet]
        [Route("dameun500")]
        public IActionResult dameun500()
        {
            try
            {
                throw new Exception("Toma un 500!");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Problem("Toma 500");
            }
        }

        [HttpGet]
        [Route("/encolame")]
        public IActionResult encolame([FromServices] IQueueService queueService)
        {
            try
            {
                if (queueService.Publish("foo", "Hello World!"))
                {
                    return Ok("Mensaje enviado a la cola");
                }
                return StatusCode(503, "Servicio no disponible");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return StatusCode(503, "Servicio no disponible");
            }
        }

        [HttpGet]
        [Route("masuno")]
        public IActionResult Get([FromServices] RedisClient redisClient)
        {
            try
            {
                int masuno = 0;
                Int32.TryParse(redisClient.Get<string>("masuno"), out masuno);
                masuno++;
                redisClient.Set<string>("masuno", masuno.ToString());

                Console.WriteLine($"Contador: {masuno}");
                return Ok($"Contador: {masuno}");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Problem(ex.Message);
            }
        }
    }
}
