#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

//#MODULE_LICENSE("GPL");

static int __init cd_init(void)
{
	printk("Carlton Draught rules!\n");
	return 0;
}

static void __exit cd_cleanup(void)
{
	printk("Drank too much Carlton...\n");
}

module_init(cd_init);
module_exit(cd_cleanup);
