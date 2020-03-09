using System;
using Microsoft.AspNetCore.Mvc;
using NATS.Client;

namespace dotnet.Controllers
{
    [ApiController]
    public class ColasController : ControllerBase
    {
        private readonly IConnection nats;
        public ColasController(IConnection nats)
        {
            this.nats = nats;
        }

        [HttpGet]
        [Route("/encolame")]
        public IActionResult encolame()
        {
            nats?.Publish("foo", System.Text.Encoding.ASCII.GetBytes("Hello World!"));
            return Ok("Mensaje enviado a la cola");
        }
    }
}
