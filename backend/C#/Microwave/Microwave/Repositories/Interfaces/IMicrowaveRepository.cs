using Microwave.Models;
namespace Microwave.Repositories.Interfaces
{
    public interface IMicrowaveRepository
    {
        Task<List<MicrowaveModel>> GetAllMicrowaves();
        Task<MicrowaveModel> GetMicrowaveById(int id);
        Task<MicrowaveModel> AddMicrowave(MicrowaveModel user);
        Task<MicrowaveModel> UpdateMicrowave(MicrowaveModel user, int id);
        Task<MicrowaveModel> DeleteMicrowave(int id);
    }
}
