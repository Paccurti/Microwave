using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microwave.Models;
using Microwave.Repositories.Interfaces;

namespace Microwave.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MicrowaveController : ControllerBase
    {
        private readonly IMicrowaveRepository _microwaveRepository;

        public MicrowaveController(IMicrowaveRepository microwaveRepository)
        {
            _microwaveRepository = microwaveRepository;
        }

        [HttpGet]

        public async Task<ActionResult<List<MicrowaveModel>>> GetAllMicrowaves()
        {
            List<MicrowaveModel> microwaves = await _microwaveRepository.GetAllMicrowaves();
            return Ok(microwaves);
        }

        [HttpGet("{id}")]

        public async Task<ActionResult<MicrowaveModel>> GetMicrowaveById(int id)
        {
            MicrowaveModel microwave = await _microwaveRepository.GetMicrowaveById(id);
            return Ok(microwave);
        }

        [HttpPost]

        public async Task<ActionResult<MicrowaveModel>> Register([FromBody] MicrowaveModel microwaveModel)
        {
            MicrowaveModel microwave = await _microwaveRepository.AddMicrowave(microwaveModel);

            return Ok(microwave);
        }

        [HttpPut("start-heating/{id}")]

        public async Task<ActionResult<MicrowaveModel>> StartHeating([FromBody] MicrowaveModel microwaveModel, int id)
        {   
            microwaveModel.Id = id;
            MicrowaveModel microwaveVerify = await _microwaveRepository.GetMicrowaveById(id);

            if(microwaveVerify.IsRunning == false)
            {
            if (microwaveModel.CookingTime > 0 && microwaveModel.CookingTime <= 120 && microwaveModel.Potency > 0 && microwaveModel.Potency <= 10)
            {
                microwaveModel.IsRunning = true;
                MicrowaveModel microwave = await _microwaveRepository.UpdateMicrowave(microwaveModel, id);

                await microwave.Start(microwave.CookingTime, microwave.Potency);

                microwaveModel.IsRunning = false;
                microwaveModel.CookingTime = 0;
                microwave = await _microwaveRepository.UpdateMicrowave(microwaveModel, id);
                return Ok(microwave);
            }
            else if (microwaveModel.CookingTime <= 0 || microwaveModel.CookingTime > 120)
            {
                return BadRequest("Insira um tempo entre 1 e 120 segundos!");
            }
            else return BadRequest("Insira uma potência entre 1 e 10!");
            } else
            {
                microwaveModel.CookingTime = microwaveModel.CookingTime + 30;
                if (microwaveModel.CookingTime > 0 && microwaveModel.CookingTime <= 120 && microwaveModel.Potency > 0 && microwaveModel.Potency <= 10)
                {
                    microwaveModel.IsRunning = true;
                    MicrowaveModel microwave = await _microwaveRepository.UpdateMicrowave(microwaveModel, id);

                    await microwave.Start(microwave.CookingTime, microwave.Potency);

                    microwaveModel.IsRunning = false;
                    microwaveModel.CookingTime = 0;
                    microwave = await _microwaveRepository.UpdateMicrowave(microwaveModel, id);

                    return Ok(microwave);
                }
                else if (microwaveModel.CookingTime <= 0 || microwaveModel.CookingTime > 120)
                {
                    return BadRequest("Insira um tempo entre 1 e 120 segundos!");
                }
                else return BadRequest("Insira uma potência entre 1 e 10!");
            }

        }

        [HttpPut("pause-or-cancel-heating/{id}")]

        public async Task<ActionResult<MicrowaveModel>> PauseOrCancelHeating([FromBody] MicrowaveModel microwaveModel, int id)
        {
            microwaveModel.Id = id;
            MicrowaveModel microwaveVerify = await _microwaveRepository.GetMicrowaveById(id);
            if(microwaveVerify.IsRunning == true)
            {
                microwaveVerify.IsRunning = false;
                MicrowaveModel microwave = await _microwaveRepository.UpdateMicrowave(microwaveVerify, id);
                return Ok(microwave);
            } else
            {
                microwaveVerify.CookingTime = 0;
                MicrowaveModel microwave = await _microwaveRepository.UpdateMicrowave(microwaveVerify, id);
                return Ok(microwave);
            }
        }

        [HttpDelete]

        public async Task<ActionResult<MicrowaveModel>> Delete(int id)
        {
            MicrowaveModel erased = await _microwaveRepository.DeleteMicrowave(id);

            return Ok($"Microondas removido");
        }
    }
}
