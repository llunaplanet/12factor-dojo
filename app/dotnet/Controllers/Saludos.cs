using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Http;
using NATS.Client;

namespace dotnet.Controllers
{
    [ApiController]
    public class SaludosController : ControllerBase
    {
        IMemoryCache cache;

        public SaludosController(IMemoryCache cache)
        {
            this.cache = cache;
        }

        [HttpGet]
        [Route("/saludos")]
        public string saludos()
        {
            string saludo = cache.Get("mot")?.ToString() ?? "Hola sin más";
            return saludo;
        }

        [HttpGet]
        [Route("/diminombre")]
        public string diminombre(string nombre)
        {            
            Response.Cookies.Append("connect.sid", nombre, new CookieOptions(){Path ="/"});
            return $"Hola {nombre}, encantado de conocerte";
        }

        [HttpGet]
        [Route("/quiensoy")]
        public string quiensoy()
        {            
            string nombre = Request.Cookies.ContainsKey("connect.sid") ? Request.Cookies["connect.sid"] : "sin nombre";
            return nombre;
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
    }
}
