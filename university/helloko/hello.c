/* hello world module - Eric McCreath 2005,2006,2008 */
/* to make use:
    make -C /scratch/linux-source-2.6.20/ SUBDIRS=$PWD modules
   to install into the kernel use :
    insmod hello.ko
   to test :
    cat /proc/hello
   to remove :
    rmmod hello
*/


#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/proc_fs.h> 

/* this is the function that the proc filesystem calls when a process 
   reads /proc/hello. It needs to return the number of bytes read */

static int hello_read_proc(char *page, char **start, off_t off,
                           int count, int *eof, void *data)
{
  int len;

  len = sprintf(page, "hello world\n");

  *start = 0;
  *eof   = 1;
  return len;
}

static struct proc_dir_entry *proc_entry;


/* this function is called by the kernel when the module is loaded */
static int __init init_hello_module(void)
{
	int		ret = 0;
	
	proc_entry = create_proc_entry("hello", S_IFREG | S_IRUGO, NULL);

       
	if (!proc_entry) {
		printk("Failed to register /proc/hello\n");
		return -1;
	}

	proc_entry->data = (void *) proc_entry;
	proc_entry->read_proc = &hello_read_proc;

	printk("init_module: done\n");
	
	return ret;
}

/* this function is called by the kernel when the module is removed */
static void __exit cleanup_hello_module(void)
{
  remove_proc_entry("hello",NULL);

  printk("cleanup_module: done\n");
}

module_init(init_hello_module);
module_exit(cleanup_hello_module);











