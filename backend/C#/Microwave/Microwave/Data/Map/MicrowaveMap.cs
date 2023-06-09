using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microwave.Models;

namespace Microwave.Data.Map
{
    public class MicrowaveMap : IEntityTypeConfiguration<MicrowaveModel>
    {
        public void Configure(EntityTypeBuilder<MicrowaveModel> builder)
        {
            builder.HasKey(x => x.Id);
            builder.Property(x => x.IsRunning).IsRequired().HasMaxLength(255);
            builder.Property(x => x.CookingTime);
            builder.Property(x => x.Potency).IsRequired();
        }
    }
}
