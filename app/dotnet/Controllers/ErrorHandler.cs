using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Diagnostics;

namespace dotnet.Controllers
{
    [ApiController]
    public class ErrorHandler : ControllerBase
    {
        [Route("/error")]
        public IActionResult Error()
        {
            var context = HttpContext.Features.Get<IExceptionHandlerFeature>();
            Console.WriteLine(context.Error.Message);
            return Problem(
                detail: context.Error.StackTrace,
                title: context.Error.Message
            );
        }
    }
}
